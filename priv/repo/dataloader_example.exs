alias ZeroPhoenix.Accounts

# Fetch 3 places we want to get the bookings for:

[person1, person2, person3] = Accounts.list_people([limit: 3])

# Create a dataloader:

loader = Dataloader.new

# Create a source which is the database repo:

source = Dataloader.Ecto.new(ZeroPhoenix.Repo)

# Add the source to the data loader. The name of the source is
# arbitrary, but typically named after a Phoenix context module.
# In this case, the name is `ZeroPhoenix.Accounts`.

loader = loader |> Dataloader.add_source(Accounts, source)

# Create a batch of bookings to be loaded (does not query the database):

loader =
  loader
  |> Dataloader.load(Accounts, :friends, person1)
  |> Dataloader.load(Accounts, :friends, person2)
  |> Dataloader.load(Accounts, :friends, person3)

# Now query the database to retrieve all queued-up friends as a batch:

loader = loader |> Dataloader.run

# 🔥 This runs one Ecto query to fetch all the bookings for all the places!

# Now you can get the bookings for a particular place:

loader |> Dataloader.load(Accounts, :friends, person1) |> IO.inspect
loader |> Dataloader.load(Accounts, :friends, person2) |> IO.inspect
loader |> Dataloader.load(Accounts, :friends, person3) |> IO.inspect
