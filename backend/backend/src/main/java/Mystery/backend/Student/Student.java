package Mystery.backend.Student;

import Mystery.backend.Product.Product;
import Mystery.backend.Reviews.UserReview;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.util.*;

@Entity
@Table(name = "students")
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "ID", updatable = false, nullable = false)
    private UUID id;
    @Column(name = "name")
    private String name;
    @Column(name = "email", unique = true)
    private String email;
    @Column(name = "phone_number", unique = true)
    private String phone;
    @Column(name = "password")
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;
    @Column(name = "class_year")
    private String classYear;
    @Column(name = "imageId")
    private String imageId;
    @Transient
    private double userRating;
    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private StudentStatus status;

    /**
     * Ask Dan for more details
     */
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "studentReviewed", orphanRemoval = true, cascade = CascadeType.ALL)
    //@OnDelete(action = OnDeleteAction.CASCADE)
    private List<UserReview> reviews = new ArrayList<>();

    /**
     * Ask Dan for more details
     */
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "student", orphanRemoval = true, cascade = CascadeType.ALL)
    //@OnDelete(action = OnDeleteAction.CASCADE)
    //@JsonManagedReference
    private Set<Product> productSet = new HashSet<Product>();

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "purchaseOwner", orphanRemoval = true, cascade = CascadeType.ALL)
    //@OnDelete(action = OnDeleteAction.CASCADE)
    private Set<Product> purchases = new HashSet<Product>();

    /**
     * Ask Dan for more details
     */
    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.MERGE, CascadeType.PERSIST})
    @JoinTable(name = "student_liked_products",
            joinColumns = @JoinColumn(name = "students_id",
                    referencedColumnName = "id"),
            inverseJoinColumns = @JoinColumn(name = "products_id",
                    referencedColumnName = "id"))
    //@OnDelete(action = OnDeleteAction.CASCADE)
    private Set<Product> likedSet = new HashSet<Product>();


    public Student() {
    }

    public Student(String name, String email, String phone, String password, String classYear, double userRating) {
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.classYear = classYear;
        this.userRating = userRating;
    }

    public Student(UUID id, String name, String email, String phone, String password, String classYear, double userRating) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.classYear = classYear;
        this.userRating = userRating;
    }

    @Override
    public String toString() {
        return "Student{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", classYear='" + classYear + '\'' +
                ", imageId=" + imageId +
                ", userRating=" + userRating +
                ", reviews=" + reviews +
                ", productSet=" + productSet +
                ", likedSet=" + likedSet +
                '}';
    }

    //very simple, integrate with name so the name must be valid with the email?
    public boolean validateUser(){
        String[] splitMail = this.getEmail().split("@");
        try {
            if (splitMail[1].equalsIgnoreCase("coloradocollege.edu")) {
                String[] splitName = splitMail[0].split("_");
                if (splitName[0].length() == 1 && splitName[1].length() >= 1) {
                    return true;
                }
            }
            return false;
        }catch(Exception e){
            return false;
        }
    }


    public Set<Product> getProductSet() {
        return productSet;
    }

    public void setProductSet(Set<Product> productSet) {
        this.productSet = productSet;
    }

    public Set<Product> getPurchases() {
        return purchases;
    }

    public void setPurchases(Set<Product> purchases) {
        this.purchases = purchases;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getClassYear() {
        return classYear;
    }

    public void setClassYear(String classYear) {
        this.classYear = classYear;
    }

    public String getImageId() {
        return imageId;
    }

    public void setImageId(String imageId) {
        this.imageId = imageId;
    }

    public double getUserRating() {
        if(reviews == null || reviews.isEmpty()){
            return 0;
        }
        double sumRating = 0;
        for (UserReview review : this.reviews){
            sumRating = sumRating + review.getValue();;
        }
        this.userRating = sumRating/reviews.size();
        return userRating;
    }

    public void setUserRating(double userRating) {
        this.userRating = userRating;
    }

    public List<UserReview> getReviews() {
        return reviews;
    }

    public void setReviews(List<UserReview> reviews) {
        this.reviews = reviews;
    }

    public void addProductToLikedSet(Product product){
        this.likedSet.add(product);
        product.getStudentsLiked().add(this);
    }

    public void removeProductFromLikedSet(UUID productId){
        Product product = this.productSet.stream().filter(productFind -> productFind.getId() == productId).findFirst().orElse(null);
        if (product != null) {
            this.productSet.remove(product);
            product.getStudentsLiked().remove(this);
        }
    }

    public Set<Product> getLikedSet() {
        return likedSet;
    }

    public void setLikedSet(Set<Product> likedSet) {
        this.likedSet = likedSet;
    }

    public StudentStatus getStatus() {
        return status;
    }

    public void setStatus(StudentStatus status) {
        this.status = status;
    }
}