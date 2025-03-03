import { db } from "@/lib/prisma";

export const getRestaurantBySlug = async (slug: string) => {
  const restaurant = await db.restaurant.findUnique({
    where: { slug },
  });

  if (!restaurant) {
    throw new Error(`Restaurant not found for slug: ${slug}`);
  }

  return restaurant;
};
