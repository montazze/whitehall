require 'test_helper'

class PublishingApiPresenters::LinkExtractorTest < ActionView::TestCase
  ALL_LINK_TYPES = [
    :document_collections,
    :lead_organisations,
    :policy_areas,
    :related_policies,
    :statistical_data_set_documents,
    :supporting_organisations,
    :topics,
    :world_locations,
    :worldwide_organisations,
    :worldwide_priorities,
  ]

  def links_for(item, filter_links = ALL_LINK_TYPES)
    LinkExtractor.new(item).extract(filter_links)
  end

  test 'nil returns a set of tags that are defaulted to []' do
    links = links_for(nil)

    ALL_LINK_TYPES.each do |link_type|
      assert_equal links[link_type], []
    end
  end

  test 'returns policy_content_id/related_policies from a document' do
    document = create(:detailed_guide)
    # policy_content_ids are an array of strings on the document
    # not a model like all others
    document.policy_content_ids = ['policy-content-id-1', 'policy-content-id-2']
    links = links_for(document)

    # whitehall names and publishing api names don't necessarily match...
    assert_equal document.policy_content_ids, links[:related_policies]
  end

  test 'extracts content_ids from a detailed guide' do
    document = create(:detailed_guide)
    links = links_for(document)

    assert_equal document.lead_organisations.map(&:content_id), links[:lead_organisations]
    # whitehall names and publishing api names don't necessarily match...
    assert_equal document.topics.map(&:content_id), links[:policy_areas]
  end
end
