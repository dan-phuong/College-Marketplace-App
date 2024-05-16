package Mystery.backend.Reviews;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface UserReviewRepository extends JpaRepository<UserReview, UUID> {
    List<UserReview> findUserReviewByStudentReviewed_Id(UUID id);

}
