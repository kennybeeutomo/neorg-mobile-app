# Neorg Mobile App
- A simple mobile application for [Neorg](https://github.com/nvim-neorg/neorg), a note taking plugin for neovim.
- Made for a college project.
- Uses flutter for frontend, and express + mysql for backend.
- Early-stage in development.

### Demo:
https://github.com/user-attachments/assets/74c8de50-3f92-4b14-a329-a0e5f5cf2226

### Features:
- [x] Able to parse neorg files and present it in a readable formatted document
- [x] Cloud storage (requires an account)
- [ ] Able to edit the formatted document without editing raw neorg files (WYSIWIG)
- [ ] Able to access and modify neorg files in Android local storage
- [ ] Support more neorg syntax

### Running:
1. Setup database using `db.sql`
2. Setup express.js backend api server. Run: `npm i && npm start` in backend directory
3. Run flutter frontend using `flutter run`
