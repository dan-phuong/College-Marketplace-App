package Mystery.backend.Tags;

import Mystery.backend.Product.Product;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "tags")
public class Tag {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "ID")
    private UUID id;
    @Column(name = "name")
    private String name;
    /**
     * Value is how many times this label tag is used
     */
    @Transient
    private int value;

    @ManyToMany(mappedBy = "tags", fetch = FetchType.LAZY,
        cascade = { CascadeType.PERSIST }
    )
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JsonIgnore
    private Set<Product> products = new HashSet<Product>();

    public Tag() {
    }

    public Tag(String name) {
        this.name = name;
        //this.value = value;
    }

    public Tag(UUID id, String name) {
        this.id = id;
        this.name = name;
        //this.value = value;
    }

    @Override
    public String toString() {
        return "Tags{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", value=" + value +
                '}';
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

    public int getValue() {
        this.value = products.size();
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }

    public Set<Product> getProducts() {
        return products;
    }

    public void setProducts(Set<Product> products) {
        this.products = products;
    }
}
