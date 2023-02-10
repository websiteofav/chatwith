enum MessageTypes {
  text('text'),
  video('video'),
  audio('audio'),
  image('image'),
  gif('gif');

  const MessageTypes(this.value);

  final String value;
}
