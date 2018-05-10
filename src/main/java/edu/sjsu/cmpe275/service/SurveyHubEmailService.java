package edu.sjsu.cmpe275.service;

import edu.sjsu.cmpe275.domain.Invitation;
import edu.sjsu.cmpe275.exceptions.InvalidOperationException;
import edu.sjsu.cmpe275.exceptions.SurveyHubException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

@Component
public class SurveyHubEmailService {
    @Autowired
    public JavaMailSender mailSender;

    private final static String FROM = "CmpE275 Survey Hub <chenhanleetcode@gmail.com>";

    public void sendInvitationMail(Invitation invitation) {
        String content = "Survey Invitation: " + invitation.getUrl();
        String subject = "Survey Invitation";
        try {
            MimeMessage mail = mailSender.createMimeMessage();
            mail.setRecipient(Message.RecipientType.TO, new InternetAddress(invitation.getToEmail()));
            mail.setFrom(new InternetAddress(FROM));
            mail.setSubject(subject);
            mail.setText(content);
            mailSender.send(mail);
        } catch (MessagingException ex) {
            throw new SurveyHubException(ex.getMessage());
        }
    }

    public void sendCreateSurveyComfirmMail(String to, String surveyId) {
        String subject = "Survey Submission Confirm";
        String content = "Your survey " + surveyId + " has submitted";
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        try {
            mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
            mimeMessage.setFrom(new InternetAddress(FROM));
            mimeMessage.setSubject(subject);
            mimeMessage.setText(content);
            mailSender.send(mimeMessage);
        } catch (MessagingException ex) {
            throw new SurveyHubException(ex.getMessage());
        }
    }

    public void sendVerificationCode(String to, String code){
        String subject = "Account SignUp Verification";
        String content = "Your verify code is: " + code;
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
            mimeMessage.setFrom(new InternetAddress(FROM));
            mimeMessage.setSubject(subject);
            mimeMessage.setText(content);
            mailSender.send(mimeMessage);
        } catch (MessagingException ex) {
            System.out.println(ex.getMessage() + " To " + to);
            throw new SurveyHubException(ex.getMessage());
        }
        System.out.println("Send Verify Code " + code);
    }
}
