import { PrismaClient } from "@prisma/client";
import { createSeedFixtures } from "./fixtures";

const prisma = new PrismaClient();

async function main() {
  const { school, student } = await createSeedFixtures(prisma, {
    teacher: "+919876500001",
    admin: "+919876500002",
    accountant: "+919876500003",
    parent: "+919876500004",
  });
  console.log("Seed complete:", { school: school.name, student: student.name });
}

main()
  .catch((err) => {
    console.error(err);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
