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
'@
