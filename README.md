# MVS RP1 Map

Deploy a Metaverse Server.

## Server Setup

### Prerequisites

- Node.js (v14 or higher recommended)
- MySQL database server
- Access to RP1 Developer Center (RP1 Developer Account + Company Name)

### Installation

1. Install dependencies:
   ```bash
   npm install
   ```

2. Configure environment variables:
   
   Create a `.env` file or set the following environment variables:
   
   - `PORT` - Server port number
   - `MYSQLHOST` - MySQL database host
   - `MYSQLPORT` - MySQL database port
   - `MYSQLUSER` - MySQL database username
   - `MYSQLPASSWORD` - MySQL database password
   - `MYSQLDATABASE` - MySQL database name
   - `PUBLIC_DOMAIN` - (Optional) Public domain for your deployment (e.g., `MYAPPURL.COM`). Falls back to   `RAILWAY_PUBLIC_DOMAIN` if not set for Railway compatibility.

   Alternatively, you can update the `settings.json` file directly with your database configuration.

3. Start the server:
   ```bash
   npm start
   ```

   For development with auto-reload:
   ```bash
   npm run dev
   ```

### Database Initialization

The server will automatically initialize the database on first run. It will:
- Create the `MVD_RP1_Map` database if it doesn't exist
- Import the schema from `MVD_RP1_Map.sql`
- Set up initial data

## Configuration

### Update fabric.msf.json

**Important:** Before running the application, you must update the `fabric.msf.json` file located in `web/public/config/`.

1. Open `web/public/config/fabric.msf.json`
2. Find the `namespace` field in the `map` object
3. Replace `mycompanyname` with your RP1 Developer Center Company name (in lowercase)

Example:
```json
{
   "map": {
      "namespace": "yourcompanyname/map",
      ...
   }
}
```

**Note:** The company name must match your RP1 Developer Center Company name exactly (must be lowercase).

## Project Structure

- `server.js` - Main server entry point
- `settings.json` - Server and database configuration
- `handler.json` - Request handler configuration
- `Handlers/` - Custom request handlers
- `web/admin/` - Admin interface files
- `web/public/` - Public web files and assets
- `web/public/config/fabric.msf.json` - Fabric configuration (requires company name update)

## Attaching Server to RP1

After your server is properly configured, deployed and running, you need to get the public URL path to your `fabric.msf.json` file to attach your server to RP1.

The URL path will be:
```
https://<YOUR_PUBLIC_DOMAIN>/config/fabric.msf.json
```

Replace `<YOUR_PUBLIC_DOMAIN>` with your actual public domain (the value you set in `PUBLIC_DOMAIN` environment variable or your deployment URL).

**Example:**
- If your `PUBLIC_DOMAIN` is `MYAPPURL.COM`, the URL would be:
  ```
  https://MYAPPURL.COM/config/fabric.msf.json
  ```

Use this URL in the RP1 Developer Center to attach your Fabric to RP1.

## License

ISC

