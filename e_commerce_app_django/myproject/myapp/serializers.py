from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Product, Category, Tag, Customer, Order, OrderItem, ShippingAddress

class UserSerializer(serializers.ModelSerializer):
    profile_pic = serializers.SerializerMethodField()
    
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'profile_pic']

    def get_profile_pic(self, obj):
        try:
            return obj.customer.profile_pic.url if obj.customer.profile_pic else None
        except:
            return None

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'

class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tag
        fields = '__all__'

class ProductSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source='category.name', read_only=True)
    tags = TagSerializer(many=True, read_only=True)

    class Meta:
        model = Product
        fields = ['id', 'name', 'price', 'description', 'image', 'category', 'category_name', 'tags', 'date_created']

class CustomerSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    class Meta:
        model = Customer
        fields = '__all__'

class OrderItemSerializer(serializers.ModelSerializer):
    product = ProductSerializer(read_only=True)
    total_price = serializers.FloatField(source='get_total', read_only=True)

    class Meta:
        model = OrderItem
        fields = ['id', 'product', 'quantity', 'total_price']

class ShippingAddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = ShippingAddress
        fields = '__all__'

class OrderSerializer(serializers.ModelSerializer):
    order_items = OrderItemSerializer(source='orderitem_set', many=True, read_only=True)
    shipping_address = serializers.SerializerMethodField()
    total_price = serializers.FloatField(source='get_cart_total', read_only=True)
    total_items = serializers.IntegerField(source='get_cart_items', read_only=True)

    class Meta:
        model = Order
        fields = ['id', 'date_ordered', 'complete', 'transaction_id', 'status', 'total_price', 'total_items', 'order_items', 'shipping_address']

    def get_shipping_address(self, obj):
        try:
            address = ShippingAddress.objects.get(order=obj)
            return ShippingAddressSerializer(address).data
        except ShippingAddress.DoesNotExist:
            return None
