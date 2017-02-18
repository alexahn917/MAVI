from django.conf.urls import url
from snipets import views
from rest_framework.urlpatterns import format_suffix_patterns


urlpatterns = [
    url(r'^snippets/$', views.SnippetList.as_view()),
    url(r'^snippets/(?P<pk>[0-9]+)/$', views.SnippetDetail.as_view()),
    url(r'^image/$', views.Upload_File.as_view()),
]

urlpatterns = format_suffix_patterns(urlpatterns)
