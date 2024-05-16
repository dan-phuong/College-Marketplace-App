package Mystery.backend.Product;


import Mystery.backend.Student.Student;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;


import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping(path = "api/product")
public class ProductController {
    private final ProductService productService;

    @Autowired
    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/getAllProducts")
    public List<Product> getAllProducts() {
        return productService.getAllProducts();
    }

    @GetMapping("/getProductById/{productId}")
    public Optional<Product> getProductById(@PathVariable("productId") UUID productId){
        return productService.getProductById(productId);
    }

    @GetMapping("/getRandomizedProducts")
    public List<Product> getRandomizedProducts(){
        return productService.getRandomizedProducts();
    }

    @GetMapping("/findProductsByTags/{tagName}")
    public List<Product> findProductByTags(@PathVariable("tagName") String name){
        return productService.findProductsByTags(name);
    }

    @GetMapping("/findOwner/{productId}")
    public Student getOwner(@PathVariable("productId") UUID productId){
        return productService.getOwner(productId);
    }

    @PutMapping("/updateProduct/{productId}")
    public void updateProduct(@PathVariable("productId") UUID id, @RequestBody Product productRequest){
        productService.updateProduct(id, productRequest);
    }

    @PostMapping("/addNewProduct/{studentId}")
    public String addNewProduct(@PathVariable("studentId") UUID studentId, @RequestBody Product productRequest){
        return productService.addNewProduct(studentId, productRequest);
    }

    @PostMapping("/purchaseProduct/{studentId}/product/{productId}")
    public String purchaseProduct(@PathVariable("studentId") UUID studentId, @PathVariable("productId") UUID productId){
        return productService.purchaseProduct(studentId, productId);
    }

    @PostMapping("/addToLiked/{studentId}/product/{productId}")
    public String addToLiked(@PathVariable("studentId") UUID studentId, @PathVariable("productId") UUID productId){
        return productService.addToLiked(studentId, productId);
    }

    @PutMapping("/removeFromLiked/{studentId}/product/{productId}")
    public String removeFromLiked(@PathVariable("studentId") UUID studentId, @PathVariable("productId") UUID productId){
        return productService.removeFromLiked(studentId, productId);
    }

    @DeleteMapping("/deleteProduct/{productId}")
    public void deleteStudent(@PathVariable("productId") UUID productId){
        productService.deleteProduct(productId);
    }

    @PostMapping("/searchFor")
    public void searchFor(@RequestBody String query){
        productService.getSearchProducts(query);
    }

}
