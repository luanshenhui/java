import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import qs from 'qs';

import PageLayout from '../../layouts/PageLayout';
import MessageBanner from '../../components/MessageBanner';
import InqwizHeaderForm from './InqwizHeaderForm';
import InqwizBody from './InqwizBody';
import Pagination from '../../components/Pagination';

const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const SearchedKeyword = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

class Inqwiz extends React.Component {
  componentWillReceiveProps(nextProps) {
    const { history } = this.props;
    const { peceiptPerId } = nextProps;

    if (peceiptPerId !== null && typeof (peceiptPerId) !== 'undefined' && peceiptPerId !== '') {
      history.push(`/contents/inquiry/inqMain/${peceiptPerId}`);
    }
  }

  render() {
    const { conditions, history, match, totalCount, data, message } = this.props;

    return (
      <PageLayout title="個人の検索">
        <MessageBanner messages={message} />
        <InqwizHeaderForm {...this.props} />
        {totalCount !== null && totalCount > 0 &&
          <div>
            <div>
              {conditions.keyword && conditions.keyword !== '' && <span>「<SearchedKeyword>{conditions.keyword}</SearchedKeyword>」の</span>}
              検索結果は<TotalCount>{totalCount}</TotalCount>件ありました。
            </div>
            <InqwizBody data={data} />
            {totalCount > conditions.limit && (
              <Pagination
                startPos={((conditions.page - 1) * conditions.limit) + 1}
                rowsPerPage={parseInt(conditions.limit, 10)}
                totalCount={totalCount}
                onSelect={(page) => {
                  // ページ番号をクリックした場合はhistory.pushによるページ遷移を行わせる
                  // 結果的にcomponentWillReceivePropsメソッドが呼ばれることにより画面の再描画が行われる
                  history.push({
                    pathname: match.url,
                    search: qs.stringify({ ...conditions, page }),
                  });
                }}
              />
            )}
          </div>
        }
      </PageLayout>
    );
  }
}

// propTypesの定義
Inqwiz.propTypes = {
  conditions: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  match: PropTypes.shape().isRequired,
  totalCount: PropTypes.number,
  data: PropTypes.arrayOf(PropTypes.shape()),
  peceiptPerId: PropTypes.string,
};

// defaultPropsの定義
Inqwiz.defaultProps = {
  data: [],
  totalCount: null,
  peceiptPerId: '',
};

const mapStateToProps = (state) => (
  {
    message: state.app.inquiry.inquiry.inqPersonList.message,
    conditions: state.app.inquiry.inquiry.inqPersonList.conditions,
    totalCount: state.app.inquiry.inquiry.inqPersonList.totalCount,
    data: state.app.inquiry.inquiry.inqPersonList.data,
    peceiptPerId: state.app.inquiry.inquiry.inqPersonList.peceiptPerId,
  }
);

export default connect(mapStateToProps)(Inqwiz);
