package Mystery.backend.Student;

import Mystery.backend.Exception.ResourceNotFoundException;
import Mystery.backend.Product.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Defines all the methods ServiceProduct uses
 */
@Service
public class StudentService {

    private final StudentRepository studentRepository;
    private BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(10);

    @Autowired
    public StudentService(StudentRepository studentRepository, ProductRepository productRepository) {
        this.studentRepository = studentRepository;
    }

    /**
     * GET Request
     * Retrieves a list of all students
     * @return - List of all students
     */
    public List<Student> getAllStudents() {
        return studentRepository.findAll();
    }

    /**
     * GET Request
     * Retrieves specified student from UUID
     * @param studentId - UUID of Student
     * @return - Specified student
     */
    public Optional<Student> getStudentById(UUID studentId) {
        return studentRepository.findById(studentId);
    }

    /**
     * POST Request
     * Logs in studentRequest by a request body
     * @param studentRequest - JSON RequestBody of Student credentials
     * @return - String indicating login outcome
     */
    public String getStudentByLogin(Student studentRequest){
        Student studentOptional = studentRepository.findStudentByEmail(studentRequest.getEmail())
                .orElseThrow(() -> new ResourceNotFoundException("No studentRequest with email: " + studentRequest.getEmail()));
        if(!encoder.matches(studentRequest.getPassword(), studentOptional.getPassword())){
            return "false";
        }
        return "true";
    }

    /**
     * POST Request
     * Logs in student by a request body
     * @param studentRequest - JSON RequestBody of Student credentials
     * @return - String indicating login outcome
     */
    public Student findStudentByEmail(Student studentRequest){
        Student studentFind = studentRepository.findStudentByEmail(studentRequest.getEmail())
                .orElseThrow(() -> new ResourceNotFoundException("No studentRequest with email: " + studentRequest.getEmail()));
        if(!encoder.matches(studentRequest.getPassword(), studentFind.getPassword())){
            return null;
        }
        return studentFind;
    }

    /**
     * PUT Mapping
     * Updates student from a request body
     * @param studentId - UUID of Student
     * @param studentRequest - JSON RequestBody of student updates
     * @return - String indicating outcome
     */
    public String updateStudent(UUID studentId, Student studentRequest){
        Student studentUpdated = studentRepository.findById(studentId)
                .orElseThrow(() -> new ResourceNotFoundException("No such student with id: " + studentId));

        studentUpdated.setName(studentRequest.getName());
        studentUpdated.setEmail(studentRequest.getEmail());
        studentUpdated.setReviews(studentRequest.getReviews());
        studentUpdated.setUserRating(studentRequest.getUserRating());
        studentUpdated.setClassYear(studentRequest.getClassYear());

        studentRepository.save(studentUpdated);
        return "Student: [" +studentId+ "] updated";
    }

    /**
     * PUT Mapping
     * Flags student for review
     * @param studentId - UUID of Student
     * @return - String indicating student has been flagged
     */
    public String flagStudent(UUID studentId){
        Student student  = studentRepository.findById(studentId)
                .orElseThrow(() -> new ResourceNotFoundException("No such student with id: " + studentId));
        student.setStatus(StudentStatus.FLAGGED);
        studentRepository.save(student);
        return "Student: [" + studentId + "] flagged";
    }

    /**
     * POST Request
     * Adds a new student into the database by a request body
     * @param studentRequest - JSON RequestBody of a Student
     * @return - String indicating outcome
     */
    public String addNewStudent(Student studentRequest) {
        if(!studentRequest.validateUser()) {
            System.out.println("Email: " + studentRequest.getEmail() + " is not valid");
            return "false";
        }
        Optional<Student> studentOptional = studentRepository.findStudentByEmail(studentRequest.getEmail());
        if (studentOptional.isPresent()) {
            System.out.println("Student: " + studentOptional.map(Student::getEmail) + " already exists");
            return "false";
        }
        String encodedPassword = encoder.encode(studentRequest.getPassword());
        Student student = new Student(
                studentRequest.getName(),
                studentRequest.getEmail(),
                studentRequest.getPhone(),
                encodedPassword,
                studentRequest.getClassYear(),
                studentRequest.getUserRating()
        );
        student.setStatus(StudentStatus.ACTIVE);

        studentRepository.save(student);
        return "true";
    }

    /**
     * DELETE Mapping
     * Deletes a student from the database by student Id
     * @param studentId - UUID of Student
     */
    public void deleteStudent(UUID studentId) {
        boolean studentExists = studentRepository.existsById(studentId);
        if (!studentExists) {
            throw new IllegalStateException(
                    "Student with id " + studentId + " does not exist");
        }
        studentRepository.deleteById(studentId);
    }

}

