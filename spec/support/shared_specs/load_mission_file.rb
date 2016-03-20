shared_examples 'load mission file' do
  it { expect { described_class.new }.to raise_error ArgumentError }

  it do
    not_readable_mission = 'spec/fixtures/not_readable_mission'
    FileUtils.chmod 'a-r', not_readable_mission
    expect { described_class.new(not_readable_mission) }
      .to raise_error(Errno::EACCES)
      .with_message /Permission denied/
    FileUtils.chmod 'a+r', not_readable_mission
  end

  it do
    expect { described_class.new('inexistent_file') }
      .to raise_error(Errno::ENOENT)
      .with_message /No such file or directory/
  end
end
