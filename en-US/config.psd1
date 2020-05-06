# Localized resources for PSCUC

ConvertFrom-StringData @'
# smtp server for Send-MailMessage
SmtpSmartHost   = contoso-com.mail.protection.outlook.com

# email from address when sending PIN email
From            = helpdesk@contoso.com

# email subject line when sending PIN email
Subject         = Your PIN has been reset.

# Voicemail enabled user template
templatealias   = voicemailusertemplate

# Class of Service template for voicemail enabled users
CosDisplayName  = Voice Mail User COS

# Custom HTML Missed Call Notification Templated ID
NotificationTemplateID = 2c019f05-06b0-4e47-b0ff-617883fb8331
'@