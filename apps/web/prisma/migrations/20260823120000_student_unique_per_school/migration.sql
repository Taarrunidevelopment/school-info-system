-- Student.admissionNo and Student.studentIdNumber were globally unique,
-- which blocks onboarding a second school (two schools' own numbering
-- schemes would collide). Scope both to per-school uniqueness instead.
--
-- Safe in both directions re: existing data: a global-unique constraint is
-- strictly stronger than a per-school one, so every row that already
-- satisfied the old constraint automatically satisfies the new one. No
-- backfill or data changes are needed before creating the new indexes.

-- DropIndex
DROP INDEX "Student_admissionNo_key";

-- DropIndex
DROP INDEX "Student_studentIdNumber_key";

-- CreateIndex
CREATE UNIQUE INDEX "Student_schoolId_admissionNo_key" ON "Student"("schoolId", "admissionNo");

-- CreateIndex
CREATE UNIQUE INDEX "Student_schoolId_studentIdNumber_key" ON "Student"("schoolId", "studentIdNumber");
