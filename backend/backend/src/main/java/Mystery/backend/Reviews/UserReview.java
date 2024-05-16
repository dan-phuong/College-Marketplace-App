package Mystery.backend.Reviews;

import Mystery.backend.Student.Student;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.util.UUID;

@Entity
@Table(name = "user_reviews")
public class UserReview {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "ID", updatable = false, nullable = false)
    private UUID id;
    @Column(name = "value")
    private int value;
    @Column(name = "description")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private UserReviewStatus status;

    //@ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "students_reviewed_id")
    @JsonIgnore
    private Student studentReviewed;

    public UserReview() {
    }

    public UserReview(int value, String description, UserReviewStatus status) {
        this.value = value;
        this.description = description;
        this.status = status;
    }

    public UserReview(UUID id, int value, String description, UserReviewStatus status) {
        this.id = id;
        this.value = value;
        this.description = description;
        this.status = status;
    }

    public int getValue() {
        return value;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public void setValue(int value) {
        this.value = value;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public UserReviewStatus getStatus() {
        return status;
    }

    public void setStatus(UserReviewStatus status) {
        this.status = status;
    }

    public Student getStudentReviewed() {
        return studentReviewed;
    }

    public void setStudentReviewed(Student studentReviewed) {
        this.studentReviewed = studentReviewed;
    }

    @Override
    public String toString() {
        return "UserReview{" +
                "id=" + id +
                ", value=" + value +
                ", description='" + description + '\'' +
                ", status=" + status +
                '}';
    }
}
