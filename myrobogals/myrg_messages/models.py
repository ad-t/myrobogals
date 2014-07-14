"""
    myRobogals
    myrg_message/models.py
    Custom Message, MessageDefinition model definition

    2014
    Robogals Software Team
"""

from django.db import models
from django.core import validators
from django.utils import timezone
from myrg_users.models import RobogalsUser
from myrg_groups.models import Role

from django.utils.translation import ugettext_lazy as _

class MessageDefinition(models.Model):
    sender_role = models.ForeignKey(Role)
    
    body = models.TextField(_('body'),
                            blank=False)
                            
    #variables = models.TextField(_('variables'),
    #                             blank=False)
                                   
    date_created = models.DateTimeField(_('date created'),
                                    blank=False,
                                    auto_now_add=True)
    
    # Fields that cannot be listed or filtered/sorted with
    PROTECTED_FIELDS = ()

    # Fields that cannot be listed (but can be filtered/sorted with)
    # NONVISIBLE_FIELDS = ()
    
    # Fields that cannot be written to
    READONLY_FIELDS = ("id","date_created",)
    
    class Meta:
        abstract = True
                                    
                                    
class EmailDefinition(MessageDefinition):
    sender_name = models.CharField(_('sender name'),
                                     max_length=127,
                                     blank=False)
                                     
    sender_address = models.CharField(_('sender address'),
                                     max_length=255,
                                     blank=False)
                                     
    subject = models.CharField(_('subject'),
                               max_length=255,
                               blank=False)

    html = models.BooleanField(_('html'), default=False)
    
    attachments = models.TextField(_('attachments'),
                                   null=True,
                                   blank=True)
                                    
class SMSDefinition(MessageDefinition):
    pass

    
    
    
    
    
    
    
class Message(models.Model):
    recipient_user = models.ForeignKey(RobogalsUser,
                                       blank=True,
                                       null=True)

    service_id = models.CharField(_('service id'),
                                  max_length=63,
                                  blank=True)
                                  
    service_status = models.CharField(_('service status'),
                                      max_length=31,
                                      blank=True)
                                      
    date_created = models.DateTimeField(_('date created'),
                                    blank=False,
                                    auto_now_add=True)
                                    
    date_delivered = models.DateTimeField(_('date delivered'),
                                      null=True,
                                      blank=True)
                                      
    class Meta:
        abstract = True

class EmailMessage(Message):
    definition = models.ForeignKey(EmailDefinition)
    recipient_name = models.CharField(_('recipient name'),
                                     max_length=127,
                                     blank=False)
    recipient_address = models.CharField(_('recipient address'),
                                         max_length=255,
                                         blank=False)
                                        
class SMSMessage(Message):
    definition = models.ForeignKey(SMSDefinition)
    
    recipient_number = models.CharField(_('recipient number'),
                                         max_length=15,
                                         blank=False)