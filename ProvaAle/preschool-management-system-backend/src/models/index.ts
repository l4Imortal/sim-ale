export class Student {
    constructor(public id: number, public name: string, public age: number, public classId: number) {}

    static async findAll(): Promise<Student[]> {
        // Logic to fetch all students from the database
    }

    static async findById(id: number): Promise<Student | null> {
        // Logic to fetch a student by ID from the database
    }

    static async create(studentData: Omit<Student, 'id'>): Promise<Student> {
        // Logic to create a new student in the database
    }
}

export class Teacher {
    constructor(public id: number, public name: string, public subjectId: number) {}

    static async findAll(): Promise<Teacher[]> {
        // Logic to fetch all teachers from the database
    }

    static async findById(id: number): Promise<Teacher | null> {
        // Logic to fetch a teacher by ID from the database
    }

    static async create(teacherData: Omit<Teacher, 'id'>): Promise<Teacher> {
        // Logic to create a new teacher in the database
    }
}

export class Class {
    constructor(public id: number, public name: string) {}

    static async findAll(): Promise<Class[]> {
        // Logic to fetch all classes from the database
    }

    static async findById(id: number): Promise<Class | null> {
        // Logic to fetch a class by ID from the database
    }

    static async create(classData: Omit<Class, 'id'>): Promise<Class> {
        // Logic to create a new class in the database
    }
}

export class Subject {
    constructor(public id: number, public name: string) {}

    static async findAll(): Promise<Subject[]> {
        // Logic to fetch all subjects from the database
    }

    static async findById(id: number): Promise<Subject | null> {
        // Logic to fetch a subject by ID from the database
    }

    static async create(subjectData: Omit<Subject, 'id'>): Promise<Subject> {
        // Logic to create a new subject in the database
    }
}