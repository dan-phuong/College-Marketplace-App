package Mystery.backend.Product;

import Mystery.backend.Exception.ResourceNotFoundException;
import Mystery.backend.Student.Student;
import Mystery.backend.Student.StudentRepository;
import Mystery.backend.Tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * Defines all the methods productController uses
 */
@Service
public class ProductService {
    private final ProductRepository productRepository;
    private final StudentRepository studentRepository;

    @Autowired
    public ProductService(ProductRepository productRepository, StudentRepository studentRepository) {
        this.productRepository = productRepository;
        this.studentRepository = studentRepository;
    }

    /**
     * GET Request
     * Retrieves all products from database
     * @return all products from database
     */
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    /**
     * GET Request
     * Retrieves product by ID
     * @param productId - UUID of Product
     * @return product by ID
     */
    public Optional<Product> getProductById(UUID productId) {
        return productRepository.findById(productId);
    }

    /**
     * GET Request
     * Retrieves all products randomized
     * @return randomized list of products
     */
    public List<Product> getRandomizedProducts() {
        List<Product> products = productRepository.findAll();
        Collections.shuffle(products);
        return products;
    }

    public List<Product> getStackProduct(int start, int end){
        List<Product> products = productRepository.findAll().subList(start,end);
        return products;
    }

    /**
     * GET Request
     * Retrieves all products randomized
     * @return randomized list of products
     */
    public Student getOwner(UUID productId) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("No such product with id: " + productId));
        UUID ownerId = product.getOwnerId();
        Student student = studentRepository.findById(ownerId)
                .orElseThrow(() -> new ResourceNotFoundException("No such student with id: " + ownerId));
        return student;
    }

    /**
     * GET Request
     * Retrieves a list of all products containing the specified tag name
     * @param tagName - Name of tag
     * @return a List of all products containing specified tag
     */
    public List<Product> findProductsByTags(String tagName){
        return productRepository.findByTags_Name(tagName);
    }

    /**
     * PUT Request
     * Updates product with specified changes in request body
     * @param productId - UUID of Product
     * @param productRequest - RequestBody of Product
     */
    public void updateProduct(UUID productId, Product productRequest){
        Product productUpdated = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("No product with such id: " + productId));

        productUpdated.setTitle(productRequest.getTitle());
        productUpdated.setDescription(productRequest.getDescription());
        productUpdated.setTags(productRequest.getTags());
        productUpdated.setImageIds(productRequest.getImageIds());
        productUpdated.setBuyPrice(productRequest.getBuyPrice());
        productUpdated.setStatus(productRequest.getStatus());

        productRepository.save(productUpdated);
    }

    /**
     * POST REQUEST
     * Adds product to a student's liked set
     * @param studentId - UUID of Student
     * @param productId - UUID of Product
     * @return String
     */
    public String addToLiked(UUID studentId, UUID productId) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new ResourceNotFoundException("No student with id: " + studentId));
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("No product with id: " + productId));
        if (student.getLikedSet().contains(product)) {
            return "Product already in liked list";
        }
        student.addProductToLikedSet(product);
        studentRepository.save(student);
        return "Product: [" +product.getTitle()+ "] added to Student liked set: [" + studentId+"]";
    }

    /**
     * PUT Request
     * Removes produt from a student's liked set
     * @param studentId - UUID of Student
     * @param productId - UUID of Product
     * @return String
     */
    public String removeFromLiked(UUID studentId, UUID productId) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new ResourceNotFoundException("No student with id: " + studentId));
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("No product with id: " + productId));
        if(!student.getLikedSet().contains(product)){
            return "Product not in liked set";
        }
        student.removeProductFromLikedSet(productId);
        studentRepository.save(student);
        return "Product: [" +product.getTitle()+ "] removed from Student liked set: [" + studentId+"]";
    }

    /**
     * POST Request
     * Adds a new product associated with a student
     * @param studentId - UUID of Student
     * @param productRequest - RequestBody of Product
     */
    public String addNewProduct(UUID studentId, Product productRequest) {
        productRequest.setStudent(studentRepository.findById(studentId)
                .orElseThrow(() -> new ResourceNotFoundException("No student with id: " + studentId)));
        productRepository.save(productRequest);
        return ("Product: [" + productRequest.getId()+"]\n"+productRequest.getTitle()+ "added to ["+studentId+"] inventory");
    }

    public String purchaseProduct(UUID studentId, UUID productId) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("No product with id: " + productId));
        Student previousOwner = studentRepository.findById(product.getOwnerId())
                .orElseThrow(() -> new ResourceNotFoundException("No student with id: " + studentId));

        product.setPurchaseOwner(studentRepository.findById(studentId)
                .orElseThrow(() -> new ResourceNotFoundException("No student with id: " + studentId)));

        /*
        product.setStudent(studentRepository.findById(studentId)
                .orElseThrow(() -> new ResourceNotFoundException("No student with id: " + studentId)));*/
        product.setStudent(null);
        productRepository.save(product);
        return ("Product:\n" + product.getId()+"\n"+product.getTitle()+ "\nSaved successfully");
    }

    /**
     * DELETE Request
     * Deletes product from database
     * @param productId - UUID of Product
     */
    public void deleteProduct(UUID productId) {
        boolean productExists = productRepository.existsById(productId);
        if (!productExists) {
            throw new IllegalStateException(
                    "product with id " + productId + " does not exist");
        }
        productRepository.deleteById(productId);
    }

    /**
     * GET Request
     * @param query
     * @return
     */
    // TODO: test and replace with actually good searching
    public List<Product> getSearchProducts(String query) {
        List<Product> allProducts = productRepository.findAll();
        List<Product> searchList = new ArrayList<>();
        for (Product allProduct : allProducts) {
            if (allProduct.containsQuery(query)) {
                searchList.add(allProduct);
            }
        }
        return searchList;
    }

}
