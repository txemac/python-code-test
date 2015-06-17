from django.db import models
from django.contrib.auth.models import User


class Stream(models.Model):
    user = models.ForeignKey(User)
    created_at = models.DateTimeField()