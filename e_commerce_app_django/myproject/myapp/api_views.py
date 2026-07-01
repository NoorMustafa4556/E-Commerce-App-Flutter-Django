from rest_framework import viewsets, permissions, status, generics
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from django.contrib.auth.models import User
from .models import Product, Category, Customer, Order, OrderItem, ShippingAddress
from .serializers import (
    ProductSerializer, CategorySerializer, UserSerializer, 
    OrderSerializer, OrderItemSerializer, CustomerSerializer
)
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        data = super().validate(attrs)
        serializer = UserSerializer(self.user).data
        for k, v in serializer.items():
            data[k] = v
        return data

class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer

@api_view(['POST'])
def register_user(request):
    data = request.data
    try:
        user = User.objects.create_user(
            username=data['username'],
            email=data['email'],
            password=data['password'],
            first_name=data.get('first_name', ''),
            last_name=data.get('last_name', '')
        )
        Customer.objects.get_or_create(
            user=user, 
            name=f"{user.first_name} {user.last_name}", 
            email=user.email
        )
        serializer = UserSerializer(user, many=False)
        return Response(serializer.data)
    except Exception as e:
        message = {'detail': str(e)}
        return Response(message, status=status.HTTP_400_BAD_REQUEST)

class ProductViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

    def get_queryset(self):
        queryset = Product.objects.all()
        category = self.request.query_params.get('category')
        search = self.request.query_params.get('search')
        if category:
            queryset = queryset.filter(category__id=category)
        if search:
            queryset = queryset.filter(name__icontains=search)
        return queryset

class CategoryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def get_user_profile(request):
    user = request.user
    serializer = UserSerializer(user, many=False)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def get_cart(request):
    user = request.user
    customer = user.customer
    order, created = Order.objects.get_or_create(customer=customer, complete=False)
    serializer = OrderSerializer(order, many=False)
    return Response(serializer.data)

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def update_cart_item(request):
    user = request.user
    data = request.data
    product_id = data.get('productId')
    action = data.get('action')

    customer = user.customer
    product = Product.objects.get(id=product_id)
    order, created = Order.objects.get_or_create(customer=customer, complete=False)

    order_item, created = OrderItem.objects.get_or_create(order=order, product=product)

    if action == 'add':
        order_item.quantity = (order_item.quantity + 1)
    elif action == 'remove':
        order_item.quantity = (order_item.quantity - 1)
    elif action == 'delete':
        order_item.quantity = 0

    order_item.save()

    if order_item.quantity <= 0:
        order_item.delete()

    return Response({'detail': 'Cart updated'})

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def checkout(request):
    user = request.user
    data = request.data
    customer = user.customer
    order, created = Order.objects.get_or_create(customer=customer, complete=False)

    # Process order logic similar to original views.py
    order.complete = True
    order.status = 'Pending'
    order.save()

    shipping_data = data.get('shipping', {})
    ShippingAddress.objects.create(
        customer=customer,
        order=order,
        address=shipping_data.get('address'),
        city=shipping_data.get('city'),
        state=shipping_data.get('state'),
        zipcode=shipping_data.get('zipcode'),
    )

    return Response({'detail': 'Order placed successfully', 'order_id': order.id})

@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def get_my_orders(request):
    user = request.user
    customer = user.customer
    orders = Order.objects.filter(customer=customer, complete=True).order_by('-date_ordered')
    serializer = OrderSerializer(orders, many=True)
    return Response(serializer.data)

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def verify_password(request):
    user = request.user
    data = request.data
    password = data.get('password')
    
    if user.check_password(password):
        return Response({'detail': 'Password verified'})
    else:
        return Response({'detail': 'Invalid password'}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def update_profile(request):
    user = request.user
    data = request.data
    
    user.first_name = data.get('first_name', user.first_name)
    user.last_name = data.get('last_name', user.last_name)
    user.email = data.get('email', user.email)
    
    if 'password' in data and data['password']:
        user.set_password(data['password'])
        
    user.save()
    
    # Update Customer
    customer = user.customer
    customer.name = f"{user.first_name} {user.last_name}"
    customer.email = user.email
    
    if 'profile_pic' in request.FILES:
        customer.profile_pic = request.FILES['profile_pic']
        
    customer.save()
    
    serializer = UserSerializer(user, many=False)
    return Response(serializer.data)
