-- Seed data with Indian phone numbers, for pasting into the Supabase SQL editor.
-- Equivalent to `npm run seed:india`. Run it ONCE on an empty database.
-- "updatedAt" has no database default (Prisma sets it client-side), so it is supplied here.

BEGIN;

WITH
  school AS (
    INSERT INTO "School" ("name", "updatedAt")
    VALUES ('Greenwood High', now())
    RETURNING "id"
  ),
  year AS (
    INSERT INTO "AcademicYear" ("schoolId", "name", "startDate", "endDate", "status", "updatedAt")
    SELECT "id", '2026-27', '2026-06-01', '2027-04-30', 'active', now() FROM school
    RETURNING "id"
  ),
  grade AS (
    INSERT INTO "Grade" ("schoolId", "name", "sortOrder", "updatedAt")
    SELECT "id", 'Grade 5', 5, now() FROM school
    RETURNING "id"
  ),
  subject AS (
    INSERT INTO "Subject" ("gradeId", "name", "updatedAt")
    SELECT "id", 'Mathematics', now() FROM grade
    RETURNING "id"
  ),
  class_a AS (
    INSERT INTO "Class" ("schoolId", "gradeId", "section", "academicYearId", "updatedAt")
    SELECT school."id", grade."id", 'A', year."id", now() FROM school, grade, year
    RETURNING "id"
  ),
  users AS (
    INSERT INTO "User" ("phone", "role", "name", "schoolId", "updatedAt")
    SELECT v.phone, v.role::"Role", v.name, school."id", now()
    FROM school,
         (VALUES
           ('+919876500001', 'teacher',    'Anitha Rao'),
           ('+919876500002', 'admin',      'Rajesh Kumar'),
           ('+919876500003', 'accountant', 'Meena Iyer'),
           ('+919876500004', 'parent',     'Priya Sharma')
         ) AS v(phone, role, name)
    RETURNING "id", "role"
  ),
  student AS (
    INSERT INTO "Student" ("schoolId", "name", "dob", "admissionNo", "updatedAt")
    SELECT "id", 'Rohan Sharma', '2015-04-12', 'GH-2026-001', now() FROM school
    RETURNING "id"
  ),
  enrollment AS (
    INSERT INTO "Enrollment" ("studentId", "classId", "academicYearId", "status", "rollNumber", "updatedAt")
    SELECT student."id", class_a."id", year."id", 'active', 'GH-2026-001', now()
    FROM student, class_a, year
    RETURNING "id"
  ),
  parent_link AS (
    INSERT INTO "ParentStudent" ("parentUserId", "studentId", "updatedAt")
    SELECT users."id", student."id", now()
    FROM users, student
    WHERE users."role" = 'parent'
    RETURNING "id"
  )
INSERT INTO "ClassTeacher" ("classId", "teacherUserId", "subjectId", "academicYearId", "updatedAt")
SELECT class_a."id", users."id", subject."id", year."id", now()
FROM class_a, users, subject, year
WHERE users."role" = 'teacher';

COMMIT;

-- Check: should return the four users with +91 numbers.
SELECT "name", "role", "phone" FROM "User" ORDER BY "id";
