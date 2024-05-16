package Mystery.backend.EmailAuthentication;

import jakarta.mail.MessagingException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Random;

@RestController
@RequestMapping(path = "api/email")
public class EmailSenderController {
    private final EmailSenderService senderService;
    private static String code;

    @Autowired
    public EmailSenderController(EmailSenderService senderService) {
        this.senderService = senderService;
    }

    @GetMapping("/authenticate/retrieve/{recipient}")
    public String sendMail(@PathVariable("recipient") String recipient) throws MessagingException {
        code = randomCode();
        senderService.sendSimpleEmail(recipient,
                "Welcome to CC Marketplace!",
                "Welcome to the CC Marketplace App!\n\nPlease enter code "+ code +" to verify your email\n\n\nHappy Valentine's Day and end of block!!!!");
    return "Email sent";
    }

    @PostMapping("/authenticate/send/{userCode}")
    public String verifyEmail(@PathVariable("userCode") String userCode){
        if (userCode.equals(code)) {
            return "Verified";
        } else{
            return "Unverified";
        }
    }

    /**
     * Generate random code from 000000 - 999999
     * @return String of a random code
     */
    public static String randomCode() {
        Random rnd = new Random();
        int number = rnd.nextInt(999999);
        return String.format("%06d", number);
    }
}
