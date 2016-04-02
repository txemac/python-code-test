# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stream', '0001_initial'),
        ('items', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='photoitem',
            name='stream',
            field=models.ForeignKey(to='stream.Stream', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='tweetitem',
            name='stream',
            field=models.ForeignKey(to='stream.Stream', null=True),
            preserve_default=True,
        ),
    ]
