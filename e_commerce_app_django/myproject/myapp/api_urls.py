from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .api_views import (
    ProductViewSet, CategoryViewSet, MyTokenObtainPairView,
    register_user, get_user_profile, get_cart, update_cart_item,
    checkout, get_my_orders, verify_password, update_profile
)
from drf_spectacular.views import SpectacularAPIView, SpectacularRedocView, SpectacularSwaggerView

router = DefaultRouter()
router.register(r'products', ProductViewSet)
router.register(r'categories', CategoryViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('users/login/', MyTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('users/register/', register_user, name='register'),
    path('users/profile/', get_user_profile, name='user_profile'),
    path('users/verify-password/', verify_password, name='verify_password'),
    path('users/update-profile/', update_profile, name='update_profile'),
    path('cart/', get_cart, name='get_cart'),
    path('cart/update/', update_cart_item, name='update_cart'),
    path('checkout/', checkout, name='checkout'),
    path('orders/my/', get_my_orders, name='my_orders'),
    
    # API Documentation
    path('schema/', SpectacularAPIView.as_view(), name='schema'),
    path('docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
]
