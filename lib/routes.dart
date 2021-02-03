enum Routes {
  // Home
  home,
  battle,
  reference,
  inventory,
  notes,

// General
  about,
  account,
  settings,
  backup,
  dice,

  // Campaigns
  campaignsList,

  // Custom Classes
  customClassesList,
  customClassCreate,
  customClassEdit,

  // Characters
  characterList,
  characterCreate,
  characterEdit,
  statEdit,

  // Moves
  moveAdd,
  moveEdit,

  // RaceMoves
  raceMoveAdd,
  raceMoveEdit,

  // Spells
  spellAdd,
  spellEdit,

  // Inventory Items
  itemAdd,
  itemEdit,

  // Notes
  noteAdd,
  noteEdit,
}

extension RouteData on Routes {
  String get path => routePaths[this];
  String get analyticsName => routeNames[this];
}

final routePaths = <Routes, String>{
  // Home
  Routes.home: '/',
  Routes.battle: '/battle',
  Routes.reference: '/reference',
  Routes.inventory: '/inventory',
  Routes.notes: '/notes',

  // General
  Routes.about: '/about',
  Routes.account: '/account',
  Routes.settings: '/settings',
  Routes.backup: '/settings/backup',
  Routes.dice: '/dice',

  // Campaigns
  Routes.campaignsList: '/campaigns',

  // Custom Classes
  Routes.customClassesList: '/custom-classes',
  Routes.customClassCreate: '/custom-classes/create',
  Routes.customClassEdit: '/custom-classes/edit',

  // Characters
  Routes.characterList: '/characters',
  Routes.characterCreate: '/characters/create',
  Routes.characterEdit: '/characters/edit',
  Routes.statEdit: '/stat/edit',

  // Moves
  Routes.moveAdd: '/moves/add',
  Routes.moveEdit: '/moves/edit',

  // RaceMoves
  Routes.raceMoveAdd: '/race-moves/add',
  Routes.raceMoveEdit: '/race-moves/edit',

  // Spells
  Routes.spellAdd: '/spells/add',
  Routes.spellEdit: '/spells/edit',

  // Inventory Items
  Routes.itemAdd: '/items/add',
  Routes.itemEdit: '/items/edit',

  // Notes
  Routes.noteAdd: '/notes/add',
  Routes.noteEdit: '/notes/edit',
};

final routeNames = <Routes, String>{
  // Home
  Routes.home: 'Home',
  Routes.battle: 'Battle',
  Routes.reference: 'Reference',
  Routes.inventory: 'Inventory',
  Routes.notes: 'Notes',

  // General
  Routes.about: 'About',
  Routes.account: 'Account',
  Routes.settings: 'Settings',
  Routes.backup: 'Backup',
  Routes.dice: 'Dice',

  // Campaigns
  Routes.campaignsList: 'Campaigns',

  // Custom Classes
  Routes.customClassesList: 'Custom Classes',
  Routes.customClassCreate: 'Create Custom Class',
  Routes.customClassEdit: 'Edit Custom Class',

  // Characters
  Routes.characterList: 'Characters',
  Routes.characterCreate: 'Create Character',
  Routes.characterEdit: 'Edit Character',
  Routes.statEdit: 'Edit Stat',

  // Moves
  Routes.moveAdd: 'Add Move',
  Routes.moveEdit: 'Edit Moves',

  // RaceMoves
  Routes.raceMoveAdd: 'Add Race move',
  Routes.raceMoveEdit: 'Edit Race Moves',

  // Spells
  Routes.spellAdd: 'Add Spell',
  Routes.spellEdit: 'Edit Spell',

  // Inventory Items
  Routes.itemAdd: 'Add Item',
  Routes.itemEdit: 'Edit Item',

  // Notes
  Routes.noteAdd: 'Add Note',
  Routes.noteEdit: 'Edit Note',
};
