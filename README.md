# Standalone-House-Purchase-V1
This script enables players to buy, explore, and exit houses on standalone FiveM servers. Configure locations in server.lua and client interactions in client.lua. Currently, it doesn't save house data between server restarts or player logins. Feedback and suggestions are appreciated!

**Overview:**

I’m excited to share a script designed for standalone FiveM servers that lets players purchase, explore, and exit houses. This script provides configuration options for setting house locations and customizing details through the `server.lua` and `client.lua` files. Note that the current version does not save player-purchased homes, so properties will not persist through server restarts or player logins. A feature to save homes is planned for future updates.

**Features:**

- **House Purchase System:** Players can buy houses within the game.
- **Exploration:** Purchased houses can be entered and explored.
- **Exit Functionality:** Players can exit their homes.

**Configuration Details:**

1. **`server.lua`:** 
   - Manages server-side logic for house purchases and interactions.
   - **House Locations:** Configure house placement and metadata.
   - **Purchasing Logic:** Handles in-game currency exchange and ownership.

2. **`client.lua`:**
   - Manages client-side interactions with houses.
   - **Entering and Exiting Houses:** Controls animations and transitions.
   - **User Interface:** Manages UI elements for house purchasing and exploration.

**Known Limitations:**

- **No Persistent Data Storage:** Homes are not saved between sessions.
  - **Server Restarts:** Purchased homes will be reset.
  - **Player Disconnects:** Homes are not retained when players leave.
- **Future Updates:** A system to save and load homes is in development.

**Usage Instructions:**

1. **Installation:**
   - Place `server.lua` and `client.lua` in the `resources` directory of your FiveM server.
   - Reference the script in your `server.cfg` with `ensure standalone_homes`.

2. **Configuration:**
   - Edit `server.lua` to set house locations and server-side settings.
   - Modify `client.lua` for client-side interactions and UI.
   - Restart your server to apply changes.

3. **Testing:**
   - Test the script to ensure functionality for house purchases, exploration, and exiting.
   - Verify configurations and make adjustments as needed.

**Feedback and Suggestions:**

I welcome your feedback! If you encounter issues or have suggestions for improvement, please let me know. Your input will help enhance the script.

**Future Developments:**

- **Persistent Data Storage:** Working on saving player-purchased homes across sessions.
- **Additional Features:** Pricing for homes to show a price on the purchase (this is almost finished, so release could be soon)

---

Feel free to adjust this as needed to fit your specific requirements or additional details.
