package Mystery.backend.Reviews;

import org.apache.catalina.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("api/review")
public class UserReviewController {
    private final UserReviewService userReviewService;

    @Autowired
    public UserReviewController(UserReviewService userReviewService){
        this.userReviewService = userReviewService;
    }

    @GetMapping("/getReviewById/{reviewId}")
    public Optional<UserReview> getReviewById(@PathVariable("reviewId") UUID reviewId){
        return userReviewService.getReviewById(reviewId);
    }

    @GetMapping("/getAllReviews")
    public List<UserReview> getAllReviews(){
        return userReviewService.getAllReviews();
    }

    @GetMapping("/findReviewsOfUser/{studentId}")
    public List<UserReview> findReviewsOfUser(@PathVariable("studentId") UUID studentId){
        return userReviewService.findReviewsOfUser(studentId);
    }

    @PutMapping("/flagReview/{reviewId}")
    public String flagReview(@PathVariable("reviewId") UUID reviewId){
        return userReviewService.flagReview(reviewId);
    }

    @PutMapping("/updateReview/{reviewId}")
    public String updateReview(@PathVariable("reviewId") UUID reviewId, @RequestBody UserReview reviewRequest){
        return userReviewService.updateReview(reviewId, reviewRequest);
    }

    @PostMapping("/addReview/{studentId}")
    public String addReview(@PathVariable("studentId") UUID studentId, @RequestBody UserReview reviewRequest){
        return userReviewService.addReview(studentId, reviewRequest);
    }

    @DeleteMapping("/delete/{reviewId}")
    public String deleteReview(@PathVariable("reviewId") UUID reviewId){
        return userReviewService.deleteReview(reviewId);
    }
}
