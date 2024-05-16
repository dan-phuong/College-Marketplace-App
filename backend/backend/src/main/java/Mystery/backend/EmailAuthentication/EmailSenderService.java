package Mystery.backend.EmailAuthentication;

import Mystery.backend.Student.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailSenderService {
    private final JavaMailSender mailSender;
    private final StudentRepository studentRepository;

    @Autowired
    public EmailSenderService(JavaMailSender mailSender, StudentRepository studentRepository) {
        this.mailSender = mailSender;
        this.studentRepository = studentRepository;
    }

    public void sendSimpleEmail(String recipient,
                                String subject,
                                String body
    ) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("ccmarketplace.tsp@gmail.com");
        message.setTo(recipient);
        message.setText(body);
        message.setSubject(subject);
        mailSender.send(message);
        System.out.println("Mail Send...");
    }
}
