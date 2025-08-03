import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/home/presentation/components/drawer_item.dart';

class DrawerItems {

  static const blog = DrawerItem(
    title: "Blog",
    icon: IconoirIcons.book,
  );

  static const profile = DrawerItem(
    title: "Profile",
    icon: IconoirIcons.peopleTag,
  );

  static const services = DrawerItem(
    title: "Services",
    icon: IconoirIcons.suitcase,
  );

  static const search = DrawerItem(
    title: "Search",
    icon: IconoirIcons.search,
  );

  static const messages = DrawerItem(
    title: "Messages",
    icon: IconoirIcons.message,
  );

  static const shop = DrawerItem(
    title: "Shop",
    icon: IconoirIcons.shop,
  );

  static const setting = DrawerItem(
    title: "Settings",
    icon: IconoirIcons.settings,
  );

  static const logout = DrawerItem(
    title: "Logout",
    icon: IconoirIcons.logOut,
  );

  static final List<DrawerItem> all = [blog, services, search, messages, shop, setting, logout];
}
