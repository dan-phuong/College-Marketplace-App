package Mystery.backend.ImageFileStorage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

@RestController
@RequestMapping(path = "api/image")
public class StorageController {
    private final StorageService storageService;

    @Autowired
    public StorageController(StorageService storageService) {
        this.storageService = storageService;
    }

    @PostMapping("/uploadProduct/{productId}")
    public ResponseEntity<?> uploadProductImage(@PathVariable("productId") UUID productId, @RequestParam("image") MultipartFile file) throws IOException {
        String uploadImage = storageService.uploadProductImage(productId, file );
        return ResponseEntity.status(HttpStatus.OK)
                .body(uploadImage);
    }

    @GetMapping("/downloadProduct/{fileName}")
    public ResponseEntity<?> downloadProductImage(@PathVariable("fileName") String fileName) throws IOException {
        byte[] imageData= storageService.downloadProductImage(fileName);
        return ResponseEntity.status(HttpStatus.OK)
                .contentType(MediaType.valueOf("image/png"))
                .body(imageData);

    }

    @PostMapping("/uploadProfile/{studentId}")
    public ResponseEntity<?> uploadProfileImage(@PathVariable("studentId") UUID studentId, @RequestParam("image") MultipartFile file) throws IOException {
        String uploadImage = storageService.uploadProfileImage(studentId, file);
        return ResponseEntity.status(HttpStatus.OK)
                .body(uploadImage);
    }

    @GetMapping("/downloadProfile/{fileName}")
    public ResponseEntity<?> downloadProfileImage(@PathVariable("fileName") String fileName) throws IOException {
        byte[] imageData= storageService.downloadProfileImage(fileName);
        return ResponseEntity.status(HttpStatus.OK)
                .contentType(MediaType.valueOf("image/png"))
                .body(imageData);

    }
}
