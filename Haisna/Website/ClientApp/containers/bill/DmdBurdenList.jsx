import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import qs from 'qs';
import { FieldSet } from '../../components/Field';
import Label from '../../components/control/Label';
import Pagination from '../../components/Pagination';
import PageLayout from '../../layouts/PageLayout';
import DmdBurdenListBody from './DmdBurdenListBody';
import DmdBurdenListHeaderForm from './DmdBurdenListHeaderForm';
import CircularProgress from '../../components/control/CircularProgress/CircularProgress';

const Font = styled.span`
    color:#${(props) => props.color};
`;

const DmdBurdenList = (props) => {
  const { allCount, conditions, history, match, isLoading } = props;
  return (
    <PageLayout title="請求書検索">
      {isLoading && <CircularProgress />}
      <DmdBurdenListHeaderForm {...this.props} />
      <br />
      {allCount !== null && (
        <div>
          {(conditions.strDate !== conditions.endDate) && (
            <FieldSet>
              { conditions.strDate < conditions.endDate && (
              <Label>「<Font color="ff6600">{conditions.strDate && conditions.endDate !== null && <b> {conditions.strDate}~{conditions.endDate}</b>}</Font>」の請求書一覧を表示しています。</Label>
                          )}
              {conditions.strDate > conditions.endDate && (
              <Label>「<Font color="ff6600">{conditions.strDate && conditions.endDate !== null && <b> {conditions.endDate}~{conditions.strDate}</b>}</Font>」の請求書一覧を表示しています。</Label>
                )}
            </FieldSet>
          )}
          {(conditions.strDate === conditions.endDate) && (
            <FieldSet>
              <Label>「<Font color="ff6600">{conditions.strDate && conditions.endDate !== null && <b> {conditions.strDate}</b>}</Font>」の請求書一覧を表示しています。</Label>
            </FieldSet>
          )}
          <FieldSet>
            <Label><Font color="ff6600"><b>{allCount}</b></Font>件の請求情報(請求書枚数単位)があります。</Label>
          </FieldSet>
          {allCount > 0 && (
            <div>
              <DmdBurdenListBody />
              {allCount > conditions.getCount && (
                <Pagination
                  startPos={(conditions.startPos)}
                  rowsPerPage={Number(conditions.getCount)}
                  totalCount={allCount}
                  onSelect={(page) => {
                    // ページ番号をクリックした場合はhistory.pushによるページ遷移を行わせる
                    // 結果的にcomponentWillReceivePropsメソッドが呼ばれることにより画面の再描画が行われる
                    history.push({
                      pathname: match.url,
                      search: qs.stringify({ ...conditions, page, startPos: ((page - 1) * conditions.getCount) + 1 }),
                    });
                  }}
                />
              )}
            </div>
          )}
        </div>
      )}
    </PageLayout>
  );
};
// propTypesの定義
DmdBurdenList.propTypes = {
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  conditions: PropTypes.shape().isRequired,
  allCount: PropTypes.number,
  isLoading: PropTypes.bool.isRequired,
};
DmdBurdenList.defaultProps = {
  allCount: null,
};
// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  conditions: state.app.bill.demand.dmdBurdenList.conditions,
  allCount: state.app.bill.demand.dmdBurdenList.allCount,
  isLoading: state.app.bill.demand.dmdBurdenList.isLoading,
});


export default connect(mapStateToProps)(DmdBurdenList);
