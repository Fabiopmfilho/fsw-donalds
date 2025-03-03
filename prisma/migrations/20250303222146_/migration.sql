/*
  Warnings:

  - The values [TAKE_AWAY] on the enum `ConsumptionMethod` will be removed. If these variants are still used in the database, this will fail.
  - The values [CANCELLED] on the enum `OrderStatus` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the `menuCategory` table. If the table is not empty, all the data it contains will be lost.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "ConsumptionMethod_new" AS ENUM ('TAKEAWAY', 'DINE_IN');
ALTER TABLE "Order" ALTER COLUMN "consumptionMethod" TYPE "ConsumptionMethod_new" USING ("consumptionMethod"::text::"ConsumptionMethod_new");
ALTER TYPE "ConsumptionMethod" RENAME TO "ConsumptionMethod_old";
ALTER TYPE "ConsumptionMethod_new" RENAME TO "ConsumptionMethod";
DROP TYPE "ConsumptionMethod_old";
COMMIT;

-- AlterEnum
BEGIN;
CREATE TYPE "OrderStatus_new" AS ENUM ('PENDING', 'IN_PREPARATION', 'FINISHED');
ALTER TABLE "Order" ALTER COLUMN "status" TYPE "OrderStatus_new" USING ("status"::text::"OrderStatus_new");
ALTER TYPE "OrderStatus" RENAME TO "OrderStatus_old";
ALTER TYPE "OrderStatus_new" RENAME TO "OrderStatus";
DROP TYPE "OrderStatus_old";
COMMIT;

-- DropForeignKey
ALTER TABLE "Product" DROP CONSTRAINT "Product_menuCategoryId_fkey";

-- DropForeignKey
ALTER TABLE "menuCategory" DROP CONSTRAINT "menuCategory_restaurantId_fkey";

-- DropTable
DROP TABLE "menuCategory";

-- CreateTable
CREATE TABLE "MenuCategory" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "restaurantId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MenuCategory_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "MenuCategory" ADD CONSTRAINT "MenuCategory_restaurantId_fkey" FOREIGN KEY ("restaurantId") REFERENCES "Restaurant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_menuCategoryId_fkey" FOREIGN KEY ("menuCategoryId") REFERENCES "MenuCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;
