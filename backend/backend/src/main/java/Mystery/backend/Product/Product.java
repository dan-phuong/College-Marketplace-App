package Mystery.backend.Product;

import Mystery.backend.Student.Student;
import Mystery.backend.Tags.Tag;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.time.LocalDate;
import java.util.*;

@Entity
@Table(name = "products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "ID")
    private UUID id;
    @Column(name = "title")
    private String title;
    @Column(name = "description")
    private String description;
    @Column(name = "date_listed")
    private LocalDate dateListed;

    /**
     * Tags many-to-many implementation. It works. Do NOT TOUCH. Talk to Dan if you want to change it.
     */
    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinTable(name = "product_tags",
            joinColumns = @JoinColumn(name = "products_id",
                    referencedColumnName = "id"),
            inverseJoinColumns = @JoinColumn(name = "tags_id",
                    referencedColumnName = "id"))
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Set<Tag> tags = new HashSet<>(5);

    @Column(name = "image_ids")
    private List<String> imageIds = new ArrayList<>();
    @Column(name = "buy_price")
    private double buyPrice;
    @Enumerated(EnumType.STRING)

    /**
     * Talk to Dan for more details
     */
    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "students_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JsonIgnore
    private Student student;

    /**
     * Talk to Dan for more details
     */
    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "purchaseOwners_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JsonIgnore
    private Student purchaseOwner;


    /**
     * Talk to Dan for more details
     */
    @ManyToMany(mappedBy = "likedSet", fetch = FetchType.LAZY,
            cascade = { CascadeType.PERSIST, CascadeType.MERGE }
    )
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JsonIgnore
    private Set<Student> studentsLiked = new HashSet<>();

    @Column(name = "status")
    private ProductStatus status;

    public Product() {
    }

    public Product(String title, String description, LocalDate dateListed, Set<Tag> tags, List<String> imageIds, double buyPrice, ProductStatus status) {
        this.title = title;
        this.description = description;
        this.dateListed = dateListed;
        this.tags = tags;
        this.imageIds = imageIds;
        this.buyPrice = buyPrice;
        this.status = status;
    }

    public Product(UUID id, String title, String description, LocalDate dateListed, Set<Tag> tags, List<String> imageIds, double buyPrice, ProductStatus status) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.dateListed = dateListed;
        this.tags = tags;
        this.imageIds = imageIds;
        this.buyPrice = buyPrice;
        this.status = status;
    }

    public boolean containsQuery(String query) {
        if((title + "" + description).contains(query)){
            return true;
        }
        for(Tag tag : tags){
            if(tag.getName().contains(query)) {
                return true;
            }
        }
        return false;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDate getDateListed() {
        return dateListed;
    }

    public void setDateListed(LocalDate dateListed) {
        this.dateListed = dateListed;
    }

    public Set<Tag> getTags() {
        return tags;
    }

    public void setTags(Set<Tag> tags) {
        this.tags = tags;
    }

    public void addTag(Tag tag){
        this.tags.add(tag);
        tag.getProducts().add(this);
    }

    public void removeTag(String tagName){
        Tag tag = this.tags.stream().filter(t -> t.getName() == tagName).findFirst().orElse(null);
        if(tag != null){
            this.tags.remove(tag);
            tag.getProducts().remove(this);
        }
    }

    public String addImageId(String imageId){
        if(this.imageIds.size() == 5){
            return "Product images full";
        }
        this.imageIds.add(imageId);
        return "Added product image";
    }

    public List<String> getImageIds() {
        return imageIds;
    }

    public void setImageIds(List<String> imageIds) {
        this.imageIds = imageIds;
    }

    public double getBuyPrice() {
        return buyPrice;
    }

    public void setBuyPrice(double buyPrice) {
        this.buyPrice = buyPrice;
    }

    public UUID getOwnerId() {
        if(this.student == null ){
            return null;
        }
        return student.getId();
    }

    public Student getPurchaseOwner() {
        return purchaseOwner;
    }

    public void setPurchaseOwner(Student purchaseOwner) {
        this.purchaseOwner = purchaseOwner;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public ProductStatus getStatus() {
        return status;
    }

    public void setStatus(ProductStatus status) {
        this.status = status;
    }

    public Set<Student> getStudentsLiked() {
        return studentsLiked;
    }

    public void setStudentsLiked(Set<Student> studentsLiked) {
        this.studentsLiked = studentsLiked;
    }

    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", dateListed=" + dateListed +
                ", tags=" + tags +
                ", imageIds=" + imageIds +
                ", buyPrice=" + buyPrice +
                ", status=" + status +
                '}';
    }
}
