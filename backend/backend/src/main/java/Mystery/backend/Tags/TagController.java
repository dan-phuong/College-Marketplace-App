package Mystery.backend.Tags;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping(path = "api/tag")
public class TagController {
    private final TagService tagService;

    @Autowired
    public TagController(TagService tagService){
        this.tagService = tagService;
    }

    @GetMapping("/getAllTags")
    public List<Tag> getAllTags(){
        return tagService.getAllTags();
    }

    @GetMapping("/getTagById/{tagId}")
    public Optional<Tag> getTagById(@PathVariable("tagId") UUID tagId){
        return tagService.getTagById(tagId);
    }

    @GetMapping("/getTags/{productId}/tags")
    public List<Tag> getTagsByProductId(@PathVariable("productId") UUID productId){
        return tagService.getTagsByProductId(productId);
    }

    @PostMapping("/addTagById/{productId}/tags/{tagId}")
    public String addTagById(@PathVariable("productId") UUID productId, @PathVariable("tagId") UUID tagId){
        return tagService.addTagById(productId, tagId);
    }

    @PostMapping("/addTagByName/{productId}/tags/{tagName}")
    public String addTagByName(@PathVariable("productId") UUID productId, @PathVariable("tagName") String tagName){
        return tagService.addTagByName(productId, tagName);
    }

    @PostMapping("/addTag/{productId}/tags")
    public String addTag(@PathVariable("productId") UUID productId, @RequestBody Tag tagRequest){
        return tagService.addTag(productId, tagRequest);
    }

    @PutMapping("/deleteTagFromProduct/{productId}/tags/{tagName}")
    public String deleteTagFromProduct(@PathVariable("productId") UUID productId, @PathVariable("tagName") String tagName){
        return tagService.deleteTagFromProduct(productId, tagName);
    }

    @DeleteMapping("/delete/{tagId}")
    public String deleteTag(@PathVariable("tagId") UUID tagID){
        return tagService.deleteTag(tagID);
    }
    @DeleteMapping("/deleteByName/{tagName}")
    public String deleteTagByName(@PathVariable("tagName") String tagName){
        return tagService.deleteTagByName(tagName);
    }

}
