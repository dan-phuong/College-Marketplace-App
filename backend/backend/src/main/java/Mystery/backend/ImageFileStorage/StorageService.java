package Mystery.backend.ImageFileStorage;

import Mystery.backend.Exception.ResourceNotFoundException;
import Mystery.backend.Product.Product;
import Mystery.backend.Product.ProductRepository;
import Mystery.backend.Student.Student;
import Mystery.backend.Student.StudentRepository;
import jakarta.persistence.GeneratedValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Optional;
import java.util.Random;
import java.util.UUID;

@Service
public class StorageService {
    private final FileDataRepository fileDataRepository;
    private final StudentRepository studentRepository;
    private final ProductRepository productRepository;
    private final String product_path = "/home/qgroup/productImages/";
    private final String profile_path = "/home/qgroup/profileImages/";

    @Autowired
    public StorageService(FileDataRepository fileDataRepository, StudentRepository studentRepository, ProductRepository productRepository) {
        this.fileDataRepository = fileDataRepository;
        this.studentRepository = studentRepository;
        this.productRepository = productRepository;
    }

    public String uploadProductImage(UUID productId, MultipartFile file) throws IOException {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("No such product with id: " + productId));
        String fileName = randomCode()+"."+file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".") + 1);
        String added = product.addImageId(fileName);
        productRepository.save(product);

        String filePath=product_path+fileName;
        FileData fileData=fileDataRepository.save(FileData.builder()
                .name(fileName)
                .type(file.getContentType())
                .filePath(filePath).build());

        file.transferTo(new File(filePath));

        if (fileData != null) {
            return added + "\nProduct image uploaded successfully at : " + filePath;
        }
        return null;
    }

    public byte[] downloadProductImage(String fileName) throws IOException {
        Optional<FileData> fileData = fileDataRepository.findByName(fileName);
        String filePath=fileData.get().getFilePath();
        byte[] images = Files.readAllBytes(new File(filePath).toPath());
        return images;
    }

    public String uploadProfileImage(UUID studentId, MultipartFile file) throws IOException {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new ResourceNotFoundException("No such student with id : " + studentId));
        String fileName = randomCode()+"."+file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".") + 1);
        student.setImageId(fileName);
        studentRepository.save(student);

        String filePath=profile_path+fileName;
        FileData fileData=fileDataRepository.save(FileData.builder()
                .name(fileName)
                .type(file.getContentType())
                .filePath(filePath).build());

        file.transferTo(new File(filePath));

        if (fileData != null) {
            return "Profile image uploaded successfully at : " + filePath;
        }
        return null;
    }

    public byte[] downloadProfileImage(String fileName) throws IOException {
        Optional<FileData> fileData = fileDataRepository.findByName(fileName);
        String filePath=fileData.get().getFilePath();
        byte[] images = Files.readAllBytes(new File(filePath).toPath());
        return images;
    }

    /**
     * Generate random code from 000000 - 999999
     * @return String of a random code
     */
    public static String randomCode() {
        Random rnd = new Random();
        int number = rnd.nextInt(100000000,999999999);
        return String.format("%09d", number);
    }
}
