import React from 'react';
import PropTypes from 'prop-types';
import GuideButton from '../../components/GuideButton';
import Chip from '../../components/Chip';
import OrgGuide from '../common/OrgGuide';
import organizationService from '../../services/preference/organizationService';

// 団体名称の取得
class DailyListOrg extends React.Component {
  constructor(props) {
    super(props);
    this.state = { orgSName: '' };
  }

  componentDidMount() {
    const { params } = this.props;
    const { orgCd1, orgCd2 } = params;
    this.getOrgInfo(orgCd1, orgCd2);
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { params } = nextProps;
    const { orgCd1, orgCd2 } = params;
    this.getOrgInfo(orgCd1, orgCd2);
  }

  onSelected = (selectedItem) => {
    this.setOrgInfo(selectedItem.org);
  }

  getOrgInfo(orgCd1, orgCd2) {
    const { setNewParams } = this.props;

    if (orgCd1 !== '' && orgCd2 !== '') {
      // propsで指定された汎用コードをキーに汎用レコードを得る
      // 団体情報取得
      const promise = organizationService.getOrg({ orgcd1: orgCd1, orgcd2: orgCd2 });
      promise.then((res) => {
        // stateに格納することでrenderメソッドが呼び出される
        const orgSName = res.org.orgsname;
        this.setState({ ...this.state, orgSName });
        setNewParams({ orgSName });
      });
    } else {
      this.setState({ ...this.state, orgSName: '' });
      setNewParams({ orgSName: '' });
    }
  }

  setOrgInfo(selectedItem) {
    const { setNewParams } = this.props;

    if (selectedItem) {
      const { orgcd1, orgcd2 } = selectedItem;
      setNewParams({ orgCd1: orgcd1, orgCd2: orgcd2 });
    } else {
      setNewParams({ orgCd1: '', orgCd2: '' });
    }
  }

  render() {
    const { onOpenOrgGuide } = this.props;
    const { orgSName } = this.state;

    return (
      <div>
        <div style={{ width: '74px', float: 'left' }}>受診団体：</div>
        <div style={{ float: 'left' }}><GuideButton onClick={() => { onOpenOrgGuide({ onSelected: this.onSelected }); }} /></div>
        <div style={{ width: '200px', float: 'left' }}>
          {orgSName !== '' &&
            (
            <Chip
              label={orgSName}
              onDelete={() => {
                this.setOrgInfo(null);
              }}
            />
          )}
        </div>
        <OrgGuide />
      </div>
    );
  }
}

// propTypesの定義
DailyListOrg.propTypes = {
  params: PropTypes.shape().isRequired,
  onOpenOrgGuide: PropTypes.func.isRequired,
  setNewParams: PropTypes.func.isRequired,
};


export default DailyListOrg;
