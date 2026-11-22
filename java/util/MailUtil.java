package util;

import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class MailUtil {

    private static final String SENDER_EMAIL = "leo555aung@gmail.com";
    //your-app-password
    private static final String APP_PASSWORD = "njdq lqrr icxx ciwy"; //gyug qhjb slew metj

    public static boolean sendMail(String recipientEmail, String subject) {
        
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, APP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
            message.setSubject(subject);

            // Function ထဲမှာပဲ HTML Body Content ကို အသေ ရေးထားခြင်း
            String bodyContent = """
                <!DOCTYPE html>
                <html>
                <body style="font-family: Arial, sans-serif; line-height: 1.6;">
                    <div style="max-width: 500px; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">
                        <h2 style="color: #28a745;">Account Created Successfully!</h2>
                        <p>မင်္ဂလာပါ၊ သင့်၏ အကောင့်သစ် တည်ဆောက်ခြင်း အောင်မြင်သွားပါပြီ။</p>
                        <p>ကျွန်ုပ်တို့၏ Web Application ကို စတင်အသုံးပြုနိုင်ပါပြီ။</p>
                        <hr style="border: none; border-top: 1px solid #eee;">
                        <p style="font-size: 12px; color: #777;">Thank you for registering with us.</p>
                    </div>
                </body>
                </html>
                """;

            message.setContent(bodyContent, "text/html; charset=UTF-8");

            Transport.send(message);
            return true;

        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
    
public static boolean sendOrderMail(String recipientEmail, String subject) {
        
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, APP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
            message.setSubject(subject);

            // Function ထဲမှာပဲ HTML Body Content ကို အသေ ရေးထားခြင်း
            String bodyContent = """
                <!DOCTYPE html>
                <html>
                <body style="font-family: Arial, sans-serif; line-height: 1.6;">
                    <div style="max-width: 500px; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">
                        <h2 style="color: #28a745;">Order Create Successfully!</h2>
                        <p>မင်္ဂလာပါ၊ သင့်၏ Order တင်ခြင်း အောင်မြင်သွားပါပြီ။</p>
                        
                        <hr style="border: none; border-top: 1px solid #eee;">
                        <p style="font-size: 12px; color: #777;">Thank you for ordering with us.</p>
                    </div>
                </body>
                </html>
                """;

            message.setContent(bodyContent, "text/html; charset=UTF-8");

            Transport.send(message);
            return true;

        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}