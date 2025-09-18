enum EnumData {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif'),
  link('link');

  const EnumData(this.type);
  final String type;
}

extension ConverMessage on String {
  EnumData toEnum() {
    switch (this) {
      case 'audio':
        return EnumData.audio;
      case 'image':
        return EnumData.image;
      case 'text':
        return EnumData.text;
      case 'gif':
        return EnumData.gif;
      case 'video':
        return EnumData.video;
      case 'link':
        return EnumData.link;
      default:
        return EnumData.text;
    }
  }
}
String getContactMessageText(EnumData type) {
  switch (type) {
    case EnumData.image:
      return '📷 Photo';
    case EnumData.video:
      return '📸 Video';
    case EnumData.audio:
      return '🎵 Audio';
    case EnumData.gif:
      return 'GIF';
    case EnumData.link:
      return '🔗 Link';
    default:
      return 'File';
  }
}

