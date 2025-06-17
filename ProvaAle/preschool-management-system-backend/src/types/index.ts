export interface Student {
    id: number;
    name: string;
    age: number;
    classId: number;
}

export interface Teacher {
    id: number;
    name: string;
    subjectId: number;
}

export interface Class {
    id: number;
    name: string;
    teacherId: number;
}

export interface Subject {
    id: number;
    name: string;
} 

export interface ApiResponse<T> {
    success: boolean;
    data?: T;
    message?: string;
}

export interface ApiRequest<T> {
    body: T;
    params: Record<string, any>;
    query: Record<string, any>;
}