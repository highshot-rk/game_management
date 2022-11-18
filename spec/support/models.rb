# frozen_string_literal: true
module CustomModelHelpers
  def always_has_a(attribute, value = 'something')
    it "has always a #{attribute}" do
      subject.send("#{attribute}=", nil)
      expect(subject).to have(1).error_on(attribute)
      subject.send("#{attribute}=", value)
      expect(subject).to have(0).errors_on(attribute)
    end
  end

  def always_has_unique(*attributes)
    it "has unique #{attributes.join(', ')}" do
      model = create(described_class.table_name.singularize.to_sym)

      attributes.each do |attribute|
        subject.send("#{attribute}=", model.send(attribute))
      end
      expect(subject).to have(1).error_on(attributes.first)
    end
  end
end
