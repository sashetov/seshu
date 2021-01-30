"""
Send email via smtp_host.
"""
import smtplib
import os
from email.mime.text import MIMEText
from email.header import Header
smtp_host = os.getenv("SMTP_HOSTNAME")
login = os.getenv("SMTP_LOGIN")
password = os.getenv("SMTP_PASSWORD")
recipients_emails = [login]
msg = MIMEText('body text of the mail' 'plain', 'utf-8')
msg['Subject'] = Header('subject line of my mail', 'utf-8')
msg['From'] = login
msg['To'] = ", ".join(recipients_emails)
s = smtplib.SMTP(smtp_host, 1025, timeout=10)
s.set_debuglevel(1)
try:
    s.starttls()
    s.login(login, password)
    s.sendmail(msg['From'], recipients_emails, msg.as_string())
finally:
    s.quit()
