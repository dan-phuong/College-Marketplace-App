package Mystery.backend.Tags;

import Mystery.backend.Exception.ResourceNotFoundException;
import Mystery.backend.Product.Product;
import Mystery.backend.Product.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class TagService {

    private final TagRepository tagRepository;

    private final ProductRepository productRepository;

    @Autowired
    public TagService(TagRepository tagRepository, ProductRepository productRepository){
        this.tagRepository = tagRepository;
        this.productRepository = productRepository;
    }

    public void updateTag(UUID tagId, Tag tagRequest){
        Tag tagUpdated = tagRepository.findById(tagId)
                .orElseThrow(() -> new ResourceNotFoundException("No tag with such id: " + tagId));
        tagUpdated.setName(tagRequest.getName());
        tagRepository.save(tagUpdated);
    }

    public List<Tag> getAllTags(){
        return tagRepository.findAll();
    }

    public Optional<Tag> getTagById(UUID tagId){
        return tagRepository.findById(tagId);
    }

    public List<Tag> getTagsByProductId(UUID productId){
        return tagRepository.findTagsByProducts_Id(productId);
    }

    public String addTagById(UUID productId, UUID tagId){
        Tag tag = tagRepository.findById(tagId)
                .orElseThrow(() -> new ResourceNotFoundException("No such tag with id: " + tagId));
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("No such product with id: " + productId));
        product.addTag(tag);
        productRepository.save(product);
        return "Tag: [" +tag.getName()+ "] added to Product: [" + productId+"]";
    }

    public String addTagByName(UUID productId, String tagName){
        Tag tag = tagRepository.findTagByName(tagName)
                .orElseThrow(() -> new ResourceNotFoundException("No such tag with id: " + tagName));
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("No such product with id: " + productId));
        product.addTag(tag);
        productRepository.save(product);
        return "Tag: [" +tagName+ "] added to Product: [" + productId+"]";
    }

    public String addTag(UUID productId, Tag tagRequest) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("No such product with id: " + productId));
        product.addTag(tagRequest);
        productRepository.save(product);
        tagRepository.save(tagRequest);
        return "Tag: [" +tagRequest.getName()+ "] added to Product: [" + productId + "]";
    }

    public String deleteTagFromProduct(UUID productId, String tagName){
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("No such product with id: " + productId));
        product.removeTag(tagName);
        productRepository.save(product);
        return "Tag: [" +tagName+ "] deleted from Product: [" + productId+"]";
    }

    public String deleteTag(UUID tagId){
        boolean tagExists = tagRepository.existsById(tagId);
        if(!tagExists){
            throw new IllegalStateException(
                    "Tag with id " + tagId + " does not exist");
        }
        tagRepository.deleteById(tagId);
        return "Tag deleted";
    }

    public String deleteTagByName(String tagName) {
        boolean tagExists = tagRepository.existsByName(tagName);
        if(!tagExists){
            throw new IllegalStateException(
                    "Tag with id " + tagName + " does not exist");
        }
        tagRepository.deleteByName(tagName);
        return "Tag deleted";
    }
}
