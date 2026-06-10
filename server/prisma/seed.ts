import { PrismaClient, SlotStatus } from '@prisma/client';

const prisma = new PrismaClient();

const demoUsers = [
  {
    id: '11111111-1111-4111-8111-111111111111',
    name: 'John Doe',
    email: 'john.doe@example.com',
  },
  {
    id: '22222222-2222-4222-8222-222222222222',
    name: 'Jane Smith',
    email: 'jane.smith@example.com',
  },
  {
    id: '33333333-3333-4333-8333-333333333333',
    name: 'Mike Johnson',
    email: 'mike.johnson@example.com',
  },
  {
    id: '44444444-4444-4444-8444-444444444444',
    name: 'Emily Davis',
    email: 'emily.davis@example.com',
  },
  {
    id: '55555555-5555-4555-8555-555555555555',
    name: 'David Wilson',
    email: 'david.wilson@example.com',
  },
];

async function main() {
  console.log('Clearing database...');
  await prisma.booking.deleteMany();
  await prisma.waitlist.deleteMany();
  await prisma.slot.deleteMany();
  await prisma.venue.deleteMany();
  await prisma.user.deleteMany();

  console.log('Seeding users...');
  const users = await Promise.all(
    demoUsers.map((user) => prisma.user.create({ data: user })),
  );
  console.log(`Created ${users.length} users.`);

  console.log('Seeding venues...');
  const venues = await Promise.all([
    prisma.venue.create({
      data: {
        name: 'Smash Arena Badminton Club',
        sportType: 'Badminton',
        address: '123 Court St, Sports City',
        imageUrl: 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=500',
      },
    }),
    prisma.venue.create({
      data: {
        name: 'Apex Football Turf',
        sportType: 'Football',
        address: '456 Stadium Rd, Green Field',
        imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=500',
      },
    }),
    prisma.venue.create({
      data: {
        name: 'Strikers Cricket Nets',
        sportType: 'Cricket',
        address: '789 Willow Ln, Cricket Ground',
        imageUrl: 'https://images.unsplash.com/photo-1531415080290-b9b69999c757?w=500',
      },
    }),
    prisma.venue.create({
      data: {
        name: 'Smash Point Badminton Arena',
        sportType: 'Badminton',
        address: '101 Shuttlecock Ave, Netsville',
        imageUrl: 'https://images.unsplash.com/photo-1521537634581-0dced2fee2ef?w=500',
      },
    }),
    prisma.venue.create({
      data: {
        name: 'Champions Turf & Nets',
        sportType: 'Football',
        address: '202 Pitch Blvd, Champion Town',
        imageUrl: 'https://images.unsplash.com/photo-1529900748604-07564a03e7a6?w=500',
      },
    }),
  ]);
  console.log(`Created ${venues.length} venues.`);

  console.log('Generating slots (6 AM to 10 PM, next 30 days)...');
  const slotsToCreate: any[] = [];
  const today = new Date();

  for (let dayOffset = 0; dayOffset < 30; dayOffset++) {
    // Construct local date but represent it correctly in UTC to avoid local timezone offset shifting the date
    const currentDate = new Date(Date.UTC(today.getFullYear(), today.getMonth(), today.getDate() + dayOffset));

    for (const venue of venues) {
      // 6 AM to 10 PM (22:00)
      // 1-hour slots: 6-7, 7-8, ..., 21-22 (last slot starts at 9 PM / 21:00)
      for (let hour = 6; hour < 22; hour++) {
        const startTime = new Date(currentDate);
        startTime.setUTCHours(hour, 0, 0, 0);

        const endTime = new Date(currentDate);
        endTime.setUTCHours(hour + 1, 0, 0, 0);

        slotsToCreate.push({
          venueId: venue.id,
          date: currentDate,
          startTime,
          endTime,
          status: SlotStatus.AVAILABLE,
        });
      }
    }
  }

  console.log(`Bulk inserting ${slotsToCreate.length} slots...`);
  const result = await prisma.slot.createMany({
    data: slotsToCreate,
  });
  console.log(`Successfully created ${result.count} slots.`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
