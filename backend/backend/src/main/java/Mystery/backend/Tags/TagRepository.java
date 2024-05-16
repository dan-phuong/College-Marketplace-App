package Mystery.backend.Tags;

import Mystery.backend.Product.Product;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface TagRepository extends JpaRepository<Tag, UUID> {
    List<Tag> findTagsByProducts_Id(UUID productId);

    Optional<Tag> findTagByName(String name);

    boolean existsByName(String name);

    List<Tag> deleteByName(String name);

}
