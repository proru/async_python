from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^accoutns/login/', views.login_view),
    url(r'^$', views.index, name='index'),
    url(r'^accoutns/register/', views.register_view),
    url(r'^accoutns/logout/', views.logout_view)
]
