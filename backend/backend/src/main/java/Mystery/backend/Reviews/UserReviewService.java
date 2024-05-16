package Mystery.backend.Reviews;

import Mystery.backend.Exception.ResourceNotFoundException;
import Mystery.backend.Student.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class UserReviewService {
    private final UserReviewRepository userReviewRepository;
    private final StudentRepository studentRepository;

    @Autowired
    public UserReviewService(UserReviewRepository userReviewRepository, StudentRepository studentRepository){
        this.userReviewRepository = userReviewRepository;
        this.studentRepository = studentRepository;
    }

    /**
     * GET Request
     * @param reviewId
     * @return
     */
    public Optional<UserReview> getReviewById(UUID reviewId){
        return userReviewRepository.findById(reviewId);
    }

    /**
     * GET Request
     * Retrieves all user reviews
     * @return - List of all user reviews
     */
    public List<UserReview> getAllReviews(){
        return userReviewRepository.findAll();
    }

    /**
     * GET Request
     * @param studentId
     * @return
     */
    public List<UserReview> findReviewsOfUser(UUID studentId){
        return userReviewRepository.findUserReviewByStudentReviewed_Id(studentId);
    }

    /**
     * PUT Request
     * @param reviewId
     * @param reviewRequest
     * @return
     */
    public String updateReview(UUID reviewId, UserReview reviewRequest){
        UserReview reviewUpdated = userReviewRepository.findById(reviewId)
                .orElseThrow(() -> new ResourceNotFoundException("No product with such id: " + reviewId));

        reviewUpdated.setValue(reviewRequest.getValue());
        reviewUpdated.setDescription(reviewRequest.getDescription());
        reviewUpdated.setStatus(reviewRequest.getStatus());

        userReviewRepository.save(reviewUpdated);

        return "Review: [" +reviewId+ "] updated successfully";
    }

    /**
     * PUT Request
     *
     * @param reviewId
     * @return
     */
    public String flagReview (UUID reviewId){
        UserReview review = userReviewRepository.findById(reviewId)
                .orElseThrow(() -> new ResourceNotFoundException("No review with such id: " + reviewId));
        review.setStatus(UserReviewStatus.FLAGGED);
        userReviewRepository.save(review);
        return "Review: [" +reviewId+ "] flagged";
    }

    /**
     * POST Request
     * @param studentId
     * @param reviewRequest
     * @return
     */
    public String addReview(UUID studentId, UserReview reviewRequest) {
        reviewRequest.setStudentReviewed(studentRepository.findById(studentId)
                .orElseThrow(() -> new ResourceNotFoundException("No student with id: " + studentId)));
        userReviewRepository.save(reviewRequest);
        return "Review [" + reviewRequest.getId()+ "] Saved successfully";
    }

    /**
     * DELETE Request
     *
     * @param reviewId
     * @return
     */
    public String deleteReview(UUID reviewId) {
        boolean reviewExists = userReviewRepository.existsById(reviewId);
        if(!reviewExists){
            throw new IllegalStateException(
                    "Review with id " + reviewId + " does not exist");
        }
        userReviewRepository.deleteById(reviewId);
        return "Review deleted";
    }
}
