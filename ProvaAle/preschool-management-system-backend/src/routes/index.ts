import { Router } from 'express';
import IndexController from '../controllers/index';

const router = Router();
const indexController = new IndexController();

export function setRoutes(app: Router) {
    app.get('/students', indexController.getStudents);
    app.post('/students', indexController.createStudent);
    app.get('/teachers', indexController.getTeachers);
    app.post('/teachers', indexController.createTeacher);
    app.get('/classes', indexController.getClasses);
    app.post('/classes', indexController.createClass);
    app.get('/subjects', indexController.getSubjects);
    app.post('/subjects', indexController.createSubject);
}