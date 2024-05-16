package Mystery.backend.Student;

import Mystery.backend.Product.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping(path = "api/student")
public class StudentController {
    private final StudentService studentService;

    @Autowired
    public StudentController(StudentService studentService) {
        this.studentService = studentService;
    }

    /**
     * GET Request
     * Retrieves a list of all students
     * @return - List of all students
     */
    @GetMapping("/getAllStudents")
    public List<Student> getAllStudents() {
        return studentService.getAllStudents();
    }

    /**
     * GET Request
     * Retrieves specified student from UUID
     * @param studentId - UUID of Student
     * @return - Specified student
     */
    @GetMapping("/getStudentById/{studentId}")
    public Optional<Student> getStudentById(@PathVariable("studentId") UUID studentId){
        return studentService.getStudentById(studentId);
    }

    /**
     * POST Request
     * Logs in student by a request body
     * @param studentRequest - JSON RequestBody of Student credentials
     * @return - String indicating login outcome
     */
    @PostMapping("/loginStudent")
    public String getStudentByLogin(@RequestBody Student studentRequest){
        return studentService.getStudentByLogin(studentRequest);
    }

    @PostMapping("/findStudent")
    public Student findStudentByEmail(@RequestBody Student studentRequest){
        return studentService.findStudentByEmail(studentRequest);
    }

    /**
     * POST Request
     * Adds a new student into the database by a request body
     * @param studentRequest - JSON RequestBody of a Student
     * @return - String indicating outcome
     */
    @PostMapping("/addNewStudent")
    public String addNewStudent(@RequestBody Student studentRequest){
        return studentService.addNewStudent(studentRequest);
    }

    /**
     * PUT Mapping
     * Updates student from a request body
     * @param studentId - UUID of Student
     * @param studentRequest - JSON RequestBody of student updates
     * @return - String indicating outcome
     */
    @PutMapping("/updateStudent/{studentId}")
    public String updateStudent(@PathVariable("studentId") UUID studentId, @RequestBody Student studentRequest){
        return studentService.updateStudent(studentId, studentRequest);
    }

    /**
     * PUT Mapping
     * Flags student for review
     * @param studentId - UUID of Student
     * @return - String indicating student has been flagged
     */
    @PutMapping("/flagStudent/{studentId}")
    public String flagStudent(@PathVariable("studentId") UUID studentId){
        return studentService.flagStudent(studentId);
    }

    /**
     * DELETE Mapping
     * Deletes a student from the database by student Id
     * @param studentId - UUID of Student
     */
    @DeleteMapping("/delete/{studentId}")
    public void deleteStudent(@PathVariable("studentId") UUID studentId){
        studentService.deleteStudent(studentId);
    }
}
