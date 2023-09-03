
![dojoWORLDE](https://github.com/dpinones/wordle-dojo/assets/30808181/8fe85353-f696-4b1d-9648-24cc83102806)

## Dojo Wordle


### Initial Setup

The repository already contains the `dojo-starter` as a submodule. Feel free to remove it if you prefer.

**Prerequisites:** First and foremost, ensure that Dojo is installed on your system. If it isn't, you can easily get it set up with:

```console
curl -L https://install.dojoengine.org | bash
```

Followed by:

```console
dojoup    
```

For an in-depth setup guide, consult the [Dojo book](https://book.dojoengine.org/getting-started/quick-start.html).

### Launch Dojo Wordle

After cloning the project, execute the following:

1. **Terminal 1 - Katana**:

```console
cd dojo && katana --disable-fee
```

2. **Terminal 2 - Contracts**:

```console
cd dojo && sozo build && sozo migrate
```

3. **Terminal 3 - Torii**:

```console
cd dojo-starter && torii --world 0x7d1f066a910bd86f532fa9ca66766722c20d47462fb99fb2fb0e1030262f9c5
```

4. **Terminal 4 - Client**:

```console
cd client && yarn && yarn dev
```

Upon completion, launch your browser and navigate to http://localhost:5173/.
