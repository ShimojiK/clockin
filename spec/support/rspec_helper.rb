module RspecHelper
  def lead_to actual
    expect { subject }.to actual
  end
end
